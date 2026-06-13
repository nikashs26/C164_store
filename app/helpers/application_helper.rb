module ApplicationHelper
  def format_price(amount)
    number_to_currency(amount)
  end

  def star_rating(rating)
    return content_tag(:span, "No ratings yet", class: "rating-text") if rating.nil?

    filled = "★" * rating.to_i
    empty = "☆" * (5 - rating.to_i)
    safe_join([
      content_tag(:span, filled, class: "stars"),
      content_tag(:span, empty, class: "stars stars-empty"),
      content_tag(:span, " (#{rating})", class: "rating-text")
    ])
  end

  def average_stars(product)
    avg = product.average_rating
    if avg
      safe_join([
        star_rating(avg.round),
        content_tag(:span, " — #{avg} / 5 · #{product.reviews.size} #{'review'.pluralize(product.reviews.size)}", class: "rating-text")
      ])
    else
      content_tag(:span, "No reviews yet", class: "rating-text")
    end
  end
end
