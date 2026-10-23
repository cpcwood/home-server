import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  connect () {
    this.schemeQuery = window.matchMedia('(prefers-color-scheme: dark)')
    this.schemeListener = () => this.reflect()
    this.schemeQuery.addEventListener('change', this.schemeListener)
    this.reflect()
  }

  disconnect () {
    this.schemeQuery.removeEventListener('change', this.schemeListener)
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
    this.element.setAttribute('aria-label', isDark ? 'Switch to light mode' : 'Switch to dark mode')
  }
}
