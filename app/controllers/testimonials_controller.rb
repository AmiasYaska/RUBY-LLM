class TestimonialsController < ApplicationController
  def new
    @testimonial = {}
  end

  def create
    @testimonial = params[:testimonial]
    @social_post = generate_social_post(@testimonial[:text])
    Rails.logger.info "Social post generated: #{@social_post.inspect}"
    
    respond_to do |format|
      format.turbo_stream # Triggers Turbo Stream response
      format.html { render :new } # Fallback
    end
  end

  private

  def generate_social_post(testimonial_text)
    Rails.logger.info "Generating social post for: #{testimonial_text}"
    chat = RubyLLM.chat(model: "gemini-1.5-flash")
    prompt = <<~PROMPT
      Rewrite this as a concise, bold, professional social post under 80 chars, 
      using 'Your app,' with fierce verbs and an unforgettable viral hook, 
      no emojis or filler, in the ultra-snappy style of top SaaS tweets:
      "#{testimonial_text}"
    PROMPT
    response = chat.ask(prompt)
    Rails.logger.info "Raw response: #{response.inspect}"
    response.content.strip
  rescue StandardError => e
    Rails.logger.error "Error generating post: #{e.message}"
    "Error: Could not generate post."
  end
end