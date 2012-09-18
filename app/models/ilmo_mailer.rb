class IlmoMailer < ActionMailer::Base
  default :from => "murhamaster@salamurhaajat.net"


  def referee_message(player)
    @user = player.user
    @player = player
    subject = "#{player.tournament.title}, ilmoittautuminen: #{player.user.full_name} (#{player.alias})"
    content_type 'text/plain'
    mail(:to => "tuomaristo@salamurhaajat.net", :subject => subject)
  end

  def player_message(player, username, passwd)
    @user = player.user
    @player = player
    @username = username
    @passwd = passwd
    subject = "Ilmoittautumisvahvistus turnaukseen #{player.tournament.title}"
    content_type 'text/plain'
    mail(:to => player.user.email, :subject => subject)
  end
end

