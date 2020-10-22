class ResizeObserver {
  constructor (callback) {
    this.callback = callback
  }

  observe () {
    this.callback()
  }

  unobserve () {
    // do nothing
  }
}

window.ResizeObserver = ResizeObserver

export default ResizeObserver
