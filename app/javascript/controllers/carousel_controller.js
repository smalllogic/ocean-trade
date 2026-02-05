import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["slide"]
  
  connect() {
    this.currentIndex = 0
    this.slideCount = this.slideTargets.length
    this.startAutoplay()
  }
  
  disconnect() {
    this.stopAutoplay()
  }
  
  next() {
    this.goTo((this.currentIndex + 1) % this.slideCount)
  }
  
  previous() {
    this.goTo((this.currentIndex - 1 + this.slideCount) % this.slideCount)
  }
  
  goToSlide(event) {
    const index = parseInt(event.currentTarget.dataset.slideIndex)
    this.goTo(index)
  }
  
  goTo(index) {
    // Hide current slide
    this.slideTargets[this.currentIndex].classList.remove("opacity-100")
    this.slideTargets[this.currentIndex].classList.add("opacity-0")
    
    // Update indicators
    const indicators = this.element.querySelectorAll(".carousel-indicator")
    indicators[this.currentIndex].classList.remove("bg-white")
    indicators[this.currentIndex].classList.add("bg-white/50")
    
    // Update index
    this.currentIndex = index
    
    // Show new slide
    this.slideTargets[this.currentIndex].classList.remove("opacity-0")
    this.slideTargets[this.currentIndex].classList.add("opacity-100")
    
    // Update indicators
    indicators[this.currentIndex].classList.remove("bg-white/50")
    indicators[this.currentIndex].classList.add("bg-white")
    
    // Reset autoplay
    this.stopAutoplay()
    this.startAutoplay()
  }
  
  startAutoplay() {
    this.autoplayInterval = setInterval(() => {
      this.next()
    }, 5000) // Change slide every 5 seconds
  }
  
  stopAutoplay() {
    if (this.autoplayInterval) {
      clearInterval(this.autoplayInterval)
    }
  }
}
