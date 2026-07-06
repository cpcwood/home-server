import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  connect () {
    this.reflect()
  }

  toggle () {
    const next = this.currentTheme() === 'dark' ? 'light' : 'dark'
    document.documentElement.dataset.theme = next
    localStorage.setItem('theme', next)
    this.reflect()
  }

  currentTheme () {
    return document.documentElement.dataset.theme ||
      (window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light')
  }

  reflect () {
    const isDark = this.currentTheme() === 'dark'
    this.element.setAttribute('aria-pressed', isDark)
    this.element.textContent = isDark ? 'LIGHT MODE' : 'DARK MODE'
  }
}
