// Tabs that a web app window (--app) opens go to Firefox; navigations inside
// the app window (including login redirects) stay put. Popups opened with
// window.open features are left alone, since sign-in dialogs use them. A tab
// that starts a sign-in returning to the app's site is loaded in the app
// window instead. Tabs opened from normal browser windows are not touched.

// Tabs created by window.open() without a URL, filled in by the opener
// afterwards, mapped to the app tab that opened them (or false)
const pending = new Map();

function isWeb(url) {
  return url.startsWith("http://") || url.startsWith("https://");
}

// Query parameters that sign-in pages use for where to go afterwards
const returnParams = ["continue", "followup", "next", "redirect", "redirect_uri",
  "redirect_url", "return_to", "returnto", "returnurl"];

// Approximates the registrable domain, e.g. calendar.google.com -> google.com
function site(url) {
  return new URL(url).hostname.split(".").slice(-2).join(".");
}

function returnsTo(url, appUrl) {
  for (const [name, value] of new URL(url).searchParams) {
    if (!returnParams.includes(name.toLowerCase()) || !isWeb(value)) continue;
    try {
      if (site(value) === site(appUrl)) return true;
    } catch {}
  }
  return false;
}

async function handle(tabId, url, sourceTabId) {
  const source = await chrome.tabs.get(sourceTabId);
  if (returnsTo(url, source.url)) {
    await chrome.tabs.update(sourceTabId, {url});
    chrome.tabs.remove(tabId);
  } else {
    divert(tabId, url);
  }
}

function divert(tabId, url) {
  chrome.runtime.sendNativeMessage("open_in_firefox", {url}, () => {
    if (chrome.runtime.lastError) {
      console.error(chrome.runtime.lastError.message);
      return;
    }
    chrome.tabs.remove(tabId);
  });
}

async function windowType(tabId) {
  const tab = await chrome.tabs.get(tabId);
  return (await chrome.windows.get(tab.windowId)).type;
}

async function openedFromApp(details) {
  try {
    return await windowType(details.sourceTabId) === "app" &&
      await windowType(details.tabId) === "normal";
  } catch {
    return false;
  }
}

chrome.webNavigation.onCreatedNavigationTarget.addListener((details) => {
  const fromApp = openedFromApp(details);
  if (isWeb(details.url)) {
    fromApp.then((yes) => yes && handle(details.tabId, details.url, details.sourceTabId));
  } else {
    pending.set(details.tabId, fromApp.then((yes) => yes && details.sourceTabId));
  }
});

chrome.webNavigation.onBeforeNavigate.addListener(async (details) => {
  const opener = pending.get(details.tabId);
  if (!opener || details.frameId !== 0 || !isWeb(details.url)) return;
  pending.delete(details.tabId);
  const sourceTabId = await opener;
  if (sourceTabId) handle(details.tabId, details.url, sourceTabId);
});

chrome.tabs.onRemoved.addListener((tabId) => pending.delete(tabId));
