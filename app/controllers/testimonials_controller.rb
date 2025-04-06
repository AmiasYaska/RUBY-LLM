class TestimonialsController < ApplicationController
  def new
    @testimonial = {}
  end

  def create
    @testimonial = params[:testimonial]
    @social_post = generate_social_post(@testimonial[:text])
    render :new
  end

  private

  def generate_social_post(testimonial_text)
    client = RubyLLM::Client.new
    prompt = <<~PROMPT
      Rewrite this as a concise, bold, professional social post under 80 chars, 
      using 'Your app,' with fierce verbs and an unforgettable viral hook, 
      no emojis or filler, in the ultra-snappy style of top SaaS tweets:
      "#{testimonial_text}"
    PROMPT

    response = client.generate(
      prompt: prompt,
      max_tokens: 80,  # Keep it short
      temperature: 0.7 # Balanced creativity
    )
    response.text.strip
  end
end