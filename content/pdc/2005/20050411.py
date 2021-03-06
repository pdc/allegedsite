import binascii
import md5
import random
import sha
import struct
import time

userSecrets = {'alice': '12345678', 'bob': '23456789'}


def createTicket(user, minutes=30):
    """Given a user, and expiry date, return a ticket."""
    expires = int(time.time() + minutes * 60)
    public_part = user.encode('UTF-8') + ':' + str(expires)
    check_field = md5.new(public_part + ':' + userSecrets[user]).hexdigest()
    return public_part + check_field


def checkTicket(ticket):
    """Given a ticket, return the user name or None."""
    es = ticket.split(':', 3)
    if len(es) != 3 or int(es[1]) <= time.time():
        return None
    user = es[0]
    if user not in userSecrets:
        return None
    data = ticket[:-32] + userSecrets[user]
    if md5.new(data).hexdigest() != es[2]:
        return None
    return user


def pwdencrypt(s):
    """Given a password, return a 46-byte hash mashup."""
    header = '\1\0'
    salt = struct.pack('I', random.randint(0, 0x100000000))
    hash1 = sha.new(s.encode('UTF-16LE') + salt).digest()
    hash2 = sha.new(s.upper().encode('UTF-16LE') + salt).digest()
    return header + salt + hash1 + hash2


def pwdhexencrypt(s):
    """Given a password, return the 46-byte hash mashup as a T-SQL binary literal"""
    return '0x' + binascii.b2a_hex(pwdencrypt(s)).upper()


t = createTicket('alice')
print(t)
print(checkTicket(t))
print(pwdhexencrypt('melon'))
