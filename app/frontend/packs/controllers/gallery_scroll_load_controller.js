import { Controller } from 'stimulus'

export default class extends Controller {
  static values = { page: Number, apiUrl: String }

  isLoading = false
  isRemainingPages = true

  connect () {
    this.handleScrollBind = this.handleScroll.bind(this)
    document.addEventListener('scroll', this.handleScrollBind, { capture: true, passive: true })
  }

  handleScroll () {
    const isBottomVisible = (this.element.getBoundingClientRect().bottom <= window.innerHeight)
    if (isBottomVisible && !this.isLoading && this.isRemainingPages && this.data.get('isGalleryRendered')) {
      this.loadNextPage()
    }
  }

  async loadNextPage () {
    this.isLoading = true
    try {
      this.injectLoadingIcon()
      this.fetchController = new AbortController()
      const response = await fetch(`${this.apiUrlValue}.json?page=${this.pageValue + 1}`, { signal: this.fetchController.signal })
      this.fetchController = null
      this.pageValue = this.pageValue + 1
      const imagesData = await response.json()
      const numberOfImages = imagesData.data.length
      if (numberOfImages === 0) {
        this.isRemainingPages = false
        this.isLoading = false
        this.removeLoadingIcon()
        return
      }
      this.injectImages(imagesData)
    } catch (error) {
      console.error(error)
      this.isLoading = false
      this.fetchController = null
    }
  }

  injectImages (imagesData) {
    this.imageLoadedCounter = 0
    this.imageLoadedTargetNumber = imagesData.data.length
    this.newImageElements = []
    for (let i = 0; i < imagesData.data.length; i += 1) {
      const imageData = imagesData.data[i].attributes
      const imageElement = document.createElement('li')
      imageElement.classList.add('gallery-image-container')
      imageElement.classList.add('hidden')
      imageElement.setAttribute('itemprop', 'image')
      imageElement.setAttribute('itemscope', '')
      imageElement.setAttribute('itemtype', 'https://schema.org/ImageObject')
      imageElement.innerHTML = `
        <a href='${imageData.url}' class='view-gallery-image'>
          <img src='${imageData.thumbnail_url}' class='gallery-image-thumbnail' title='${imageData.title}' alt='${imageData.description}' data-action='load->gallery-scroll-load#imageLoaded' data-justified-gallery-target='galleryItem' itemprop='contentUrl'>
        </a>
      `
      this.newImageElements.push(imageElement)
      this.element.insertAdjacentElement('beforeend', imageElement)
    }
  }

  imageLoaded () {
    this.imageLoadedCounter += 1
    if (this.imageLoadedCounter === this.imageLoadedTargetNumber) {
      this.displayGalleryItemTargets()
      this.isLoading = false
    }
  }

  displayGalleryItemTargets () {
    this.removeLoadingIcon()
    this.element.dispatchEvent(new Event('renderGallery'))
    this.element.dispatchEvent(new Event('reConnectLightbox'))
    for (let i = 0; i < this.newImageElements.length; i++) {
      this.newImageElements[i].classList.remove('hidden')
      const imgTarget = this.newImageElements[i].querySelector('img')
      imgTarget.style.transitionDelay = `${i * 0.1}s`
      imgTarget.classList.add('fade-in')
    }
  }

  injectLoadingIcon () {
    this.loadingIcon = document.createElement('div')
    this.loadingIcon.classList.add('gallery-loading-icon-container')
    this.loadingIcon.innerHTML = `
    <div class='gallery-loading-icon'>
      <div class='loading-element large'>
        <div></div>
      </div>
      <div class='loading-element small'>
        <div></div>
      </div>
      <div class='loading-element small'>
        <div></div>
      </div>
      <div class='loading-element large'>
        <div></div>
      </div>
    </div>
    `
    this.element.insertAdjacentElement('afterend', this.loadingIcon)
  }

  initializeScrollLoad () {
    this.data.set('isGalleryRendered', true)
  }

  removeLoadingIcon () {
    if (this.loadingIcon) {
      this.loadingIcon.remove()
    }
  }

  disconnect () {
    document.removeEventListener('scroll', this.handleScrollBind, true)
    if (this.fetchController) {
      this.fetchController.abort()
    }
    this.removeLoadingIcon()
  }
}
