import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = ['dragItem']

  dragStart (e) {
    // save dragItem to state since dataTransfer not available in dragOver event and DOM manipulation temporary
    this.dragItem = e.currentTarget
    e.dataTransfer.effectAllowed = 'move'
    this.dragItem.classList.add('dragging')
  }

  dragOver (e) {
    e.preventDefault()
    const dropZone = e.currentTarget
    if (dropZone !== this.dragItem && dropZone !== this.dragItem.nextElementSibling) {
      dropZone.classList.add('drag-over')
    }
    e.dataTransfer.dropEffect = 'move'
  }

  dragLeave (e) {
    const dropZone = e.currentTarget
    if (dropZone !== this.dragItem && dropZone !== this.dragItem.nextElementSibling) {
      dropZone.classList.remove('drag-over')
    }
  }

  drop (e) {
    e.stopPropagation()
    const dropZone = e.currentTarget
    if (dropZone !== this.dragItem && dropZone !== this.dragItem.nextElementSibling) {
      const container = this.dragItem.parentNode
      container.removeChild(this.dragItem)
      container.insertBefore(this.dragItem, dropZone)
    }
    dropZone.classList.remove('drag-over')
    this.dragItem.classList.remove('dragging')
    this.dragItem = null
    this.applyOrderToItems()
  }

  moveUp (e) {
    e.preventDefault()
    const targetItemSelector = e.currentTarget.getAttribute('data-item-container-selector')
    const targetItem = document.body.querySelector(targetItemSelector)
    const listContainer = targetItem.parentElement
    const sibling = targetItem.previousElementSibling
    if (sibling) {
      listContainer.removeChild(targetItem)
      listContainer.insertBefore(targetItem, sibling)
    }
    this.applyOrderToItems()
  }

  moveDown (e) {
    e.preventDefault()
    const targetItemSelector = e.currentTarget.getAttribute('data-item-container-selector')
    const targetItem = document.body.querySelector(targetItemSelector)
    const listContainer = targetItem.parentElement
    const nextSibling = targetItem.nextElementSibling
    if (nextSibling) {
      listContainer.removeChild(targetItem)
      const insertBeforeSibling = nextSibling.nextElementSibling
      if (insertBeforeSibling) {
        listContainer.insertBefore(targetItem, insertBeforeSibling)
      } else {
        listContainer.appendChild(targetItem)
      }
    }
    this.applyOrderToItems()
  }

  applyOrderToItems () {
    for (let i = 0; i < this.dragItemTargets.length; i += 1) {
      this.dragItemTargets[i].querySelector('.item-order-position').value = i
    }
  }
}
