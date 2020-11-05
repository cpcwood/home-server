import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = ['dragItem']

  connect () {
    this.dragItem = null
  }

  disconnect () {
    this.dragItem = null
  }

  dragStart (e) {
    // start drag on item
    this.dragItem = e.currentTarget

    e.dataTransfer.effectAllowed = 'move'
    e.dataTransfer.setData('text/html', this.dragItem.outerHTML)

    this.dragItem.classList.add('dragging')
  }

  dragOver (e) {
    // pings while moving over valid drop target
    if (e.preventDefault) {
      e.preventDefault()
    }

    const dropZone = e.currentTarget
    if (dropZone !== this.dragItem && dropZone !== this.dragItem.nextElementSibling.nextElementSibling && dropZone !== this.dragItem.nextElementSibling) {
      dropZone.classList.add('drag-over')
    }

    e.dataTransfer.dropEffect = 'move'
    return false
  }

  dragLeave (e) {
    // leaves valid drop target
    const dropZone = e.currentTarget
    if (this.dragItem !== dropZone) {
      dropZone.classList.remove('drag-over')
    }
  }

  drop (e) {
    // process drop
    if (e.stopPropagation) {
      e.stopPropagation()
    }

    const dropZone = e.currentTarget

    if (dropZone !== this.dragItem && dropZone !== this.dragItem.nextElementSibling.nextElementSibling && dropZone !== this.dragItem.nextElementSibling) {
      dropZone.parentNode.removeChild(this.dragItem)
      const dropHTML = e.dataTransfer.getData('text/html')
      dropZone.insertAdjacentHTML('beforebegin', dropHTML)
    }

    dropZone.classList.remove('drag-over')
    return false
  }

  dragEnd (e) {
    this.dragItem.classList.remove('dragging')
    this.dragItem = null
  }
}
