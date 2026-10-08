import { Page } from '@playwright/test'

export async function dragAndDropJS(page: Page, sourceSelector: string, targetSelector: string) {
  await page.evaluate(([srcSel, dstSel]) => {
    const src = document.querySelector(srcSel) as HTMLElement
    const dst = document.querySelector(dstSel) as HTMLElement

    if (!src || !dst) {
      throw new Error(`Cannot find source or target elements: ${srcSel}, ${dstSel}`)
    }

    // `DataTransfer` and `DragEvent` exist in browser, so TS inside `evaluate` is fine
    const dataTransfer = new DataTransfer()

    src.dispatchEvent(new DragEvent('dragstart', { bubbles: true, cancelable: true, dataTransfer }))
    dst.dispatchEvent(new DragEvent('drop', { bubbles: true, cancelable: true, dataTransfer }))
    src.dispatchEvent(new DragEvent('dragend', { bubbles: true, cancelable: true, dataTransfer }))
  }, [sourceSelector, targetSelector])
}
