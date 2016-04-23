class IlmoMailer < ActionMailer::Base
  default :from => "murhamaster@salamurhaajat.net"


  def referee_message(player)
    @user = player.user
    @player = player
    subject = "#{player.tournament.title}, ilmoittautuminen: #{player.user.full_name} (#{player.alias})"
    mail(to: ENV['REFEREE_EMAIL'], subject: subject, content_type: 'text/plain')
  end

  def player_message(player, username, passwd)
    @user = player.user
    @player = player
    @username = username
    @passwd = passwd
    subject = "Ilmoittautumisvahvistus turnaukseen #{player.tournament.title}"
    mail(to: player.user.email,  subject: subject, content_type: 'text/plain')
  end
end
