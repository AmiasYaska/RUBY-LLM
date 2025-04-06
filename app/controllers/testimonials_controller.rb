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

  # testimonial = "Your app saved us 20 hours of manual work last week, streamlining our process."
  # prompt_quote = f"Rewrite this as a 10-15 word quote, fiercely vivid with verbs like 'crushed,' professional yet dramatic, top SaaS style: '{testimonial}'"
  # prompt_social = f"Rewrite this as a concise, bold, professional social post under 80 chars, using 'Your app,' with fierce verbs and an unforgettable viral hook, no emojis or filler, in the ultra-snappy style of top SaaS tweets: '{testimonial}'"
  # prompt_case = f"Turn this into a 100-110 word case study summary (strictly enforced), using 'Your app,' inferring data entry, ultra-concise, fiercely vivid with verbs like 'crushed' or 'soared,' dramatic yet grounded, flawless grammar, no repetition of 'significant' or 'efficiency,' in the lean, ROI-obsessed style of top SaaS case studies, with a mid-sized logistics firm context and jaw-dropping quantified impact including industry-specific wins: '{testimonial}'"
  # prompt_email = f"Convert this into a 2-3 sentence email snippet, friendly yet vivid, with quantified ROI, in the crisp, engaging style of top SaaS emails: '{testimonial}'"
    
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