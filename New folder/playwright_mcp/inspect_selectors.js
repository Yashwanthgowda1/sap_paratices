const { chromium } = require('playwright');
(async () => {
  const browser = await chromium.launch({ headless: true });
  const page = await browser.newPage();
  await page.goto('https://www.hotstar.com', { waitUntil: 'networkidle', timeout: 60000 });

  const info = await page.evaluate(() => {
    return {
      title: document.title,
      dataTestIds: [...document.querySelectorAll('[data-testid]')].map(e => e.getAttribute('data-testid')).slice(0, 30),
      ariaLabels:  [...document.querySelectorAll('[aria-label]')].map(e => e.getAttribute('aria-label')).slice(0, 30),
      navLinks:    [...document.querySelectorAll('nav a, header a')].map(e => ({ text: e.textContent?.trim().substring(0,30), href: e.getAttribute('href') })).slice(0, 20),
      logoClasses: [...document.querySelectorAll('header img, header svg, [class*="logo"], [class*="Logo"]')].map(e => ({ tag: e.tagName, cls: e.className?.substring?.(0,60) })).slice(0, 5),
      searchSel:   [...document.querySelectorAll('[href*="search"], [class*="search"], [class*="Search"]')].map(e => ({ tag: e.tagName, cls: e.className?.substring?.(0,60), aria: e.getAttribute('aria-label') })).slice(0, 5),
    };
  });
  console.log(JSON.stringify(info, null, 2));
  await browser.close();
})();
