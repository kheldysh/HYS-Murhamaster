module EventsHelper
  
  def formatted_duration(tournament)
    return "#{tournament.start_date.day}.#{tournament.start_date.month}.-#{tournament.finish_date.day}.#{tournament.finish_date.month}."
  end
  
  def formatted_duration_with_year(tournament)
    return "#{formatted_duration(tournament)}#{tournament.finish_date.year}"
  end
  
  def tournament_status(tournament)
    if tournament.is_running?
      return "Peli käynnissä"
    elsif DateTime.now < tournament.app_deadline
      return "Ilmoittautuminen käynnissä"
    elsif DateTime.now > tournament.app_deadline and Date.today < tournament.start_date
      return "Ilmoittautuminen on päättynyt"
    else
      return "Peli on päättynyt"
    end
  end
    
end
