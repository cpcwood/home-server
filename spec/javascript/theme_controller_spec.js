import { Application } from '@hotwired/stimulus'
import ThemeController from '../../app/frontend/packs/controllers/theme_controller'

describe('ThemeController', () => {
  beforeEach(() => {
    document.documentElement.removeAttribute('data-theme')
    localStorage.clear()
    document.body.innerHTML = "<button data-controller='theme' data-action='click->theme#toggle'>THEME</button>"
    window.matchMedia = jest.fn().mockReturnValue({ matches: false })
    const application = Application.start()
    application.register('theme', ThemeController)
  })

  it('switches to dark and persists', () => {
    document.querySelector('button').click()
    expect(document.documentElement.dataset.theme).toEqual('dark')
    expect(localStorage.getItem('theme')).toEqual('dark')
  })

  it('switches back to light on second toggle', () => {
    document.querySelector('button').click()
    document.querySelector('button').click()
    expect(document.documentElement.dataset.theme).toEqual('light')
    expect(localStorage.getItem('theme')).toEqual('light')
  })

  it('starts from the OS preference when unset', () => {
    window.matchMedia = jest.fn().mockReturnValue({ matches: true })
    document.querySelector('button').click()
    expect(document.documentElement.dataset.theme).toEqual('light')
  })
})
