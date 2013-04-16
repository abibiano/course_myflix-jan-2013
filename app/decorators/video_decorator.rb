class VideoDecorator < Draper::Decorator
  delegate_all

  def rate_text
    if source.average_rating
      "#{source.average_rating}/5.0"
    else
      "N/A"
    end
  end
end