import { Controller } from 'stimulus'
import Typed from 'typed.js'
import Cookies from 'js-cookie'

export default class extends Controller {
  static targets = ['typedHeader', 'typedSubtitle', 'typedHeaderText', 'typedSubtitleText']

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
      typeSpeed: 55,
      startDelay: 1200,
      preStringTyped: () => {
        this.typedHeaderTarget.classList.add('typed-cursor')
      },
      onComplete: () => {
        this.typedSubtitle = new Typed('#typed-subtitle', subtitleOptions)
      }
    }

    const isHeaderTyped = Cookies.get('header-typed')

    if (!this.isPreview && !isHeaderTyped) {
      this.typedHeader = new Typed('#typed-header', headerOptions)
    } else {
      this.setHeader()
    }

    Cookies.set('header-typed', 'true', { expires: 0.02 })
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

  setHeader () {
    this.typedHeaderTarget.textContent = this.typedHeaderTextTarget.textContent
    this.typedSubtitleTarget.textContent = this.typedSubtitleTextTarget.textContent
  }
}
