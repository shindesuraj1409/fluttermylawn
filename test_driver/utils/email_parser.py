# first have to install IMAPClient via
# pip3 install imapclient
# we are getting the mail body.

# Configure Gmail settings - allow less secure apps

# Set up IMAP
# 1. On your computer, open Gmail.
# 2. In the top right, click Settings. See all settings.
# 3. Click the Forwarding and POP/IMAP tab.
# 4. In the "IMAP access" section, select Enable IMAP.
# 5. Click Save Changes.

import email
import json
import sys
from imapclient import IMAPClient

credentials = {}


def get_text(msg):
    if msg.is_multipart():
        return get_text(msg.get_payload(0))
    else:
        return msg.get_payload(None, True)


def searching_parsed_mail(email_cases, email_subject, search_string, email_body, emailll, textt):
    s = email_body.decode('UTF-8')
    if search_string == email_cases:
        if email_cases in email_subject:
            if emailll in s:
                print(email_cases + ' email is found')
                print('email subject: ' + str(email_subject))
                print('email body: ' + str(email_body))
                print('email matched: ' + emailll)
                print (textt in s)
                print ('Text found in email')
        else:
            print(email_cases + ' email is not found')


def email_parser_method(test_date, emailSub, emaill, text):
    try:
        # test_date which is passed by test cases
        emailDate = test_date
        changesDate = emailDate[:-7]
        data = ''
        email_body = ''
        email_subject = ''

        # Read credentials file
        with open('test_driver/credentials.json') as f:
            credentials = json.load(f)

        server = IMAPClient(credentials['mail_server'], use_uid=True)
        server.login(credentials['email'], credentials['password'])
        select_info = server.select_folder('INBOX')
        messages = server.search(['FROM', credentials['from_email']])

        for uid, message_data in server.fetch(messages, ['ENVELOPE']).items():
            envelope = message_data[b'ENVELOPE']
            print(envelope.subject.decode())
            print('fourdate:' + str(changesDate).replace('_', ''))
            print('fenvdate:' + str(
                str(str(str(envelope.date).replace(':', '_')).replace('-', '_')).replace(' ', '_')).replace('_', ''))
            if int(str(changesDate).replace('_', '')) < int(
                    str(str(str(str(envelope.date).replace(':', '_')).replace('-', '_')).replace(' ', '_')).replace('_',
                                                                                                                    '')):
                for second_uid, message in server.fetch(messages, ['RFC822']).items():
                    if (uid == second_uid):
                        email_message = email.message_from_bytes(message[b'RFC822'])
                        email_subject = envelope.subject.decode()
                        email_body = get_text(email_message)

        server.logout()

        searching_parsed_mail('Thank you for subscribing', email_subject, emailSub, email_body, emaill, text)

        searching_parsed_mail('Reset your MyLawn password', email_subject, emailSub, email_body, emaill, text)

    except Exception as e:
        print('Handling run-time error:', e)
        raise


# call the email parser method
email_parser_method(sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4])
