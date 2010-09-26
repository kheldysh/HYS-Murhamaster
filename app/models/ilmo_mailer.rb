class IlmoMailer < ActionMailer::Base
  

  def referee_message(player)
    @subject    = "%s, ilmoittautuminen: %s (%s)" % [ player.tournament.title, player.user.full_name, player.alias ]
    @body       = {:user => player.user, :player => player }
    @recipients = "tuomaristo@salamurhaajat.net"
    @from       = "murhamaster@salamurhaajat.net"
    @sent_on    = Time.now
    
    body       
  end

  def player_message(player)
    @subject    = "Ilmoittautumisvahvistus turnaukseen %s" % player.tournament.title
    @body       = {:user => player.user, :player => player }
    @recipients = player.user.email
    @from       = "murhamaster@salamurhaajat.net"
    @sent_on    = Time.now
  end
end
