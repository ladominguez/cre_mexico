import smtplib
email_results=True 


FROM    = 'antonio@seismo.berkeley.edu'
TO      = 'antonio@moho.ess.ucla.edu'
SUBJECT = "Hello!"
server = smtplib.SMTP('mail.geo.berkeley.edu')

#TEXT    = 'test'
#message = 'Subject: %s\n\n%s' % (SUBJECT, TEXT)
#server.sendmail(FROM, TO, message)
#server.quit()
#exit()


if email_results:
	FROM    = 'antonio@seismo.berkeley.edu'
	TO      = 'antonio@moho.ess.ucla.edu'
	SUBJECT = '[CRSMEX] Results from station ' + 'TEST'
	TEXT    = 'test'
	message = 'Subject: %s\n\n%s' % (SUBJECT, TEXT)

	server = smtplib.SMTP('mail.geo.berkeley.edu')
	server.sendmail(FROM, TO, message)
	server.quit()
