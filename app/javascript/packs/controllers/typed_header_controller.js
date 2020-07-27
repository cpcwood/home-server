import { Controller } from 'stimulus'
import Typed from 'typed.js'

export default class extends Controller {
  static targets = ['typedHeader', 'typedSubtitle']

  connect () {
    const controller = this

    const subtitleOptions = {
      stringsElement: '#typed-strings-subtitle',
      showCursor: false,
      typeSpeed: 75,
      startDelay: 700,
      preStringTyped: () => {
        this.typedSubtitleTarget.classList.add('typed_cursor')
        this.typedHeaderTarget.classList.remove('typed_cursor')
      },
      onComplete: () => {
        setTimeout(() => {
          this.typedSubtitleTarget.classList.remove('typed_cursor')
        }, 1700)
      }
    }

    const headerOptions = {
      stringsElement: '#typed-strings-header',
      showCursor: false,
      typeSpeed: 50,
      startDelay: 1700,
      preStringTyped: () => {
        this.typedHeaderTarget.classList.add('typed_cursor')
      },
      onComplete: () => {
        controller.typedSubtitle = new Typed('#typed-subtitle', subtitleOptions)
      }
    }

    controller.typedHeader = new Typed('#typed-header', headerOptions)
  }

  disconnect () {
    if (this.typedSubtitle) {
      this.typedSubtitle.destroy()
    }
    if (this.typedHeader) {
      this.typedHeader.destroy()
    }
    this.typedHeaderTarget.parentElement.parentElement.innerHTML = ''
  }
}
