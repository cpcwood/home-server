import { Controller } from 'stimulus'
import Typed from 'typed.js'

export default class extends Controller {
  static targets = ['typedHeader', 'typedSubtitle']

  connect () {
    const subtitleOptions = {
      stringsElement: '#typed-strings-subtitle',
      showCursor: false,
      typeSpeed: 75,
      startDelay: 600,
      preStringTyped: () => {
        this.typedSubtitleTarget.classList.add('typed-cursor')
        this.typedHeaderTarget.classList.remove('typed-cursor')
      },
      onComplete: () => {
        setTimeout(() => {
          this.typedSubtitleTarget.classList.remove('typed-cursor')
        }, 1700)
      }
    }

    const headerOptions = {
      stringsElement: '#typed-strings-header',
      showCursor: false,
      typeSpeed: 50,
      startDelay: 1700,
      preStringTyped: () => {
        this.typedHeaderTarget.classList.add('typed-cursor')
      },
      onComplete: () => {
        this.typedSubtitle = new Typed('#typed-subtitle', subtitleOptions)
      }
    }

    if (!this.isPreview) {
      this.typedHeader = new Typed('#typed-header', headerOptions)
    }
  }

  disconnect () {
    if (this.typedSubtitle) {
      this.typedSubtitle.destroy()
      this.typedSubtitleTarget.classList.remove('typed-cursor')
    }
    if (this.typedHeader) {
      this.typedHeader.destroy()
      this.typedHeaderTarget.classList.remove('typed-cursor')
    }
  }

  get isPreview () {
    return document.documentElement.hasAttribute('data-turbolinks-preview')
  }
}
