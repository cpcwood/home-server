import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  async connect () {
    await import('chartkick/chart.js')
    const { Chart } = await import('chart.js')
    Chart.defaults.color = '#888'
    Chart.defaults.borderColor = 'rgba(128, 128, 128, 0.2)'
  }
}
