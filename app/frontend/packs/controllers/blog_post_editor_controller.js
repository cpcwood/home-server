import { Controller } from 'stimulus'

export default class extends Controller {
  static values = { currentSectionsCount: Number }

  static targets = ['postSection']

  newPostSection (event) {
    const parentPostSectionContainer = event.target.closest('.blog-post-section')
    const clonedContainer = parentPostSectionContainer.cloneNode()
    const clonedForm = parentPostSectionContainer.querySelector('.form-fields').cloneNode(true)
    this.currentSectionsCountValue += 1

    const ruler = clonedForm.querySelector('.ruler')
    ruler.classList.remove('hidden')

    const textField = clonedForm.querySelector('.embedded-text-area.post')
    textField.value = ''
    textField.name = `post[post_sections_attributes][${this.currentSectionsCountValue}][text]`
    textField.id = `post_post_sections_attributes_${this.currentSectionsCountValue}_text`

    const orderField = clonedForm.querySelector('.item-order-position')
    orderField.value = this.currentSectionsCountValue
    orderField.name = `post[post_sections_attributes][${this.currentSectionsCountValue}][order]`
    orderField.id = `post_post_sections_attributes_${this.currentSectionsCountValue}_order`

    clonedContainer.appendChild(clonedForm)
    parentPostSectionContainer.after(clonedContainer)

    this.applyOrderToItems()
  }

  applyOrderToItems () {
    for (let i = 0; i < this.postSectionTargets.length; i += 1) {
      this.postSectionTargets[i].querySelector('.item-order-position').value = i
    }
  }
}


