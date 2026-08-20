puts '~> Creating AI models'

ai_models = [
  {
    name: 'Gemini Flash',
    slug: ENV.fetch('GEMINI_FLASH_MODEL'),
    provider: 'google',
    is_default: false,
    is_premium: true,
    active: true
  },
  {
    name: 'Gemini Flash Lite',
    slug: ENV.fetch('GEMINI_FLASH_LITE_MODEL'),
    provider: 'google',
    is_default: true,
    is_premium: false,
    active: true
  }
]

ai_models.each do |attributes|
  ai_model = AiModel.find_or_initialize_by(slug: attributes[:slug])
  ai_model.update!(attributes)
end

puts '~> Created AI models'
