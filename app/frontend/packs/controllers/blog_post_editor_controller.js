import { Controller } from 'stimulus'

export default class extends Controller {
  static values = { currentSectionsCount: Number }

  static targets = ['postSection']

  applyOrderToItems () {
    const currentPostSectionTargets = this.postSectionTargets.filter(postSection => !postSection.dataset.isDestroyed)
    for (let i = 0; i < currentPostSectionTargets.length; i += 1) {
      currentPostSectionTargets[i].querySelector('.item-order-position').value = i
    }
  }

  newPostSection (event) {
    const postSectionContainer = event.target.closest('.blog-post-section')
    this.currentSectionsCountValue += 1
    const clonedContainer = postSectionContainer.cloneNode()
    const clonedForm = postSectionContainer.querySelector('.form-fields').cloneNode(true)

    this._restorePostSectionElement(clonedContainer, clonedForm)

    const ruler = clonedForm.querySelector('.ruler')
    ruler.classList.remove('hidden')

    const textField = clonedForm.querySelector('.embedded-text-area.post')
    textField.value = ''
    textField.disabled = false
    textField.name = `post[post_sections_attributes][${this.currentSectionsCountValue}][text]`
    textField.id = `post_post_sections_attributes_${this.currentSectionsCountValue}_text`

    const orderField = clonedForm.querySelector('.item-order-position')
    orderField.value = this.currentSectionsCountValue
    orderField.name = `post[post_sections_attributes][${this.currentSectionsCountValue}][order]`
    orderField.id = `post_post_sections_attributes_${this.currentSectionsCountValue}_order`

    const destroyField = clonedForm.querySelector('.destroy-post-section')
    destroyField.value = 0
    destroyField.name = `post[post_sections_attributes][${this.currentSectionsCountValue}][_destroy]`
    destroyField.id = `post_post_sections_attributes_${this.currentSectionsCountValue}_destroy`

    clonedContainer.appendChild(clonedForm)
    postSectionContainer.after(clonedContainer)

    this.applyOrderToItems()
  }

  destroyPostSection (event) {
    const postSectionContainer = event.target.closest('.blog-post-section')
    postSectionContainer.classList.add('destroy')
    postSectionContainer.dataset.isDestroyed = true
    postSectionContainer.querySelector('.destroy-post-section').value = 1

    const textField = postSectionContainer.querySelector('.embedded-text-area.post')
    textField.disabled = true

    this.applyOrderToItems()
  }

  restorePostSection (event) {
    const postSectionContainer = event.target.closest('.blog-post-section')
    this._restorePostSectionElement(postSectionContainer)

    this.applyOrderToItems()
  }

  _restorePostSectionElement (postSectionContainer, formFields = postSectionContainer) {
    postSectionContainer.classList.remove('destroy')
    postSectionContainer.removeAttribute('data-is-destroyed')
    formFields.querySelector('.destroy-post-section').value = 0
    const textField = formFields.querySelector('.embedded-text-area.post')
    textField.disabled = false
  }
}
