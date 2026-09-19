// TEST: click through the landing page on MAIN (?site=main&suffix=LP) with 1 referral; screenshot each stage.
import { chromium } from 'playwright';
const OUT = new URL('./out/', import.meta.url).pathname;
const b = await chromium.launch(); const p = await b.newPage({ viewport: { width: 1100, height: 900 } });
const shot = async (n: string) => { await p.screenshot({ path: `${OUT}landing-${n}.png`, fullPage: true }); console.log(new Date().toLocaleTimeString('en-US', { hour12: false }), 'shot', n); };
await p.goto('http://localhost:4710/?site=main&suffix=LP');
for (const n of ['referral-02.pdf', 'referral-03.pdf']) await p.uncheck(`input[value="${n}"]`);
await p.fill('#goal', 'Enter this morning\'s referral faxes and book their first visits');
await p.setInputFiles('#rec', new URL('../recordings/20260919_172629/events.json', import.meta.url).pathname);
await shot('1-form');
await p.click('#go');
await p.waitForSelector('#s-understand.ok'); await shot('2-understand');
await p.waitForSelector('#s-login.ok, #s-login.bad', { timeout: 330000 }); await shot('3-login');
await p.waitForSelector('#s-run .st:has-text("running")', { timeout: 60000 }).catch(() => {}); await shot('4-running');
await p.waitForSelector('#s-run.ok, #s-run.bad', { timeout: 600000 }); await p.waitForTimeout(3000); await shot('5-confirm');
console.log('run step:', await p.locator('#s-run').innerText());
await p.locator('#s-take').scrollIntoViewIfNeeded(); await shot('6-take-it-with-you');
const href = await p.locator('#s-take a').getAttribute('href'); console.log('skill link', href);
await b.close();
