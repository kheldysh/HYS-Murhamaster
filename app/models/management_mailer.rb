class IlmoMailer < ActionMailer::Base
  def password_reset_message(user, password)
    @subject    = "Murhamaster-salasanasi on vaihdettu!" # "#{user.full_name}, ilmoittautuminen: %s (%s)" % [ player.tournament.title, player.user.full_name, player.alias ]
    @body       = "Hei, Murhamaster-salasanasi on vaihdettu!\n\n
                   Käyttäjätunnus: #{user.username}\n
                   Uusi salasana: #{password}"
    @recipients = user.email
    @from       = "murhamaster@salamurhaajat.net"
    @sent_on    = Time.now
  end
end