module ApplicationHelper
  include UserAuthentication

  def finnish_date(date)
    return date.strftime("%d.%m.%Y klo %H.%M")
  end

  def nil_date_handler(date)
    if date == nil
      return "Ei tietoa"
    else
      return finnish_date(date)
    end
  end
end
