// Tabs that a web app window (--app) opens go to Firefox; navigations inside
// the app window (including login redirects) stay put. Popups opened with
// window.open features are left alone, since sign-in dialogs use them. Tabs
// opened from normal browser windows are not touched.

// Tabs created by window.open() without a URL, filled in by the opener
// afterwards, mapped to whether they should go to Firefox
const pending = new Map();

function isWeb(url) {
  return url.startsWith("http://") || url.startsWith("https://");
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
    fromApp.then((yes) => yes && divert(details.tabId, details.url));
  } else {
    pending.set(details.tabId, fromApp);
  }
});

chrome.webNavigation.onBeforeNavigate.addListener(async (details) => {
  const fromApp = pending.get(details.tabId);
  if (!fromApp || details.frameId !== 0 || !isWeb(details.url)) return;
  pending.delete(details.tabId);
  if (await fromApp) divert(details.tabId, details.url);
});

chrome.tabs.onRemoved.addListener((tabId) => pending.delete(tabId));
