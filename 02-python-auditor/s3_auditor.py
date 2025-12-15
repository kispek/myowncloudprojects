import boto3
# - sprawdzenie dostpenosci bucketow 
#def audit_s3_buckets():
#    s3 = boto3.client('s3')
#    response = s3.list_buckets()
#    print(" ROZPOCZYNAM AUDYT S3 ")
#
#    if 'Buckets' in response:
#        for bucket in response['Buckets']:
 #           print(f"Znaleziono koszykL: {bucket['Name']}")
#    else:
#        print("Nie znaleziono żadnych koszyków s3.")
#

def audit_s3_buckets():
    s3 = boto3.client('s3')
    print("\n-ROZPOCEZCIE AUDYTU BEZPIECZENSTWA!!! -")
    
    try:
        response = s3.list_buckets()
    except Exception as e:
        print(f"Błąd połączenia z AWS: {e}")
        return
    public_buckets = []

    if 'Buckets' in response:
        for bucket in response['Buckets']:
            bucket_name = bucket['Name']

            try: #sprawdza tu konfiguracje public acces block
                block_config = s3.get_public_access_block(Bucket=bucket_name)
                settings = block_config['PublicAccessBlockConfiguration']
                # sprawdza czy ktorekolwiek z tych 4 puntkwo jest wylaczony
                if not settings.get('BlockPublicAcls', True) or \
                   not settings.get('IgnorePublicAcls', True) or \
                   not settings.get('BlockPublicPolicy', True) or \
                   not settings.get('RestrictPublicBuckets', True):
                    
                    public_buckets.append(bucket_name)
                    print(f" RYZYKO: Koszyk {bucket_name} MA LUB MOŻE MIEĆ PUBLICZNY DOSTEP")
                else:
                    print(f" OK: Koszyk {bucket_name} jest poprawnie zabezpieczony.")

            except s3.exceptions.NoSuchPublicAccessBlockConfiguration:
                public_buckets.append(bucket_name)
                print(f"ALARM: Koszyk {bucket_name}, NIE MA AKTYWNEJ POLITYKI 'Public Access BLock")

    print("\n PODSUMOWANIE")
    if public_buckets:
        print(f"Znaleziono {len(public_buckets)} Koszykow z ujawnieniem pbulicznym (sprawdz je!)")

    else:
        print("Wszystkie koszyki są poprawnie zabezpieczone, elo")

def audit_iam_users():
    iam = boto3.client('iam')
    print("\n Audyt bezpieczeństwa IAM - MFA/ACCESS KEY")
    try:
        users_response = iam.list_users()
    except Exception as e:
        print(f"Błąd połączenia z aws iam:{e}")
        return
    risky_users = []

    for user in users_response.get('Users', []):
        user_name = user['UserName']
        #tutaj sprawdzimy MFA
        mfa_response = iam.list_mfa_devices(UserName=user_name)
        has_mfa = len(mfa_response['MFADevices']) > 0  
        #Teraz sprawdzimy access key
        key_response = iam.list_access_keys(UserName=user_name)
        has_access_key = len(key_response['AccessKeyMetadata']) > 0
        
        #tutaj sprawdzamy czy uzytkownik uzywa access key oraz mfa
        if has_access_key and not has_mfa:
            risky_users.append(user_name)
            print(f"ALARM IAML: UŻYTKOWNIK {user_name} MA AKTYWNE ACCESS KEY ALE NIE MFA")
        elif has_access_key and has_mfa:
            print(f"OK IAML Użytkowink {user_name} używa kluczy i mfa")
        else:
            print(f"INFO: uzytkownik {user_name} nie używa access key oraz MFA")
    print("\n PODSUMOWANIE AIDYTU IAM")
    if risky_users:
        print(f"ZNALEZIONO {len(risky_users)} UŻYTKOWNIKÓW RYZYKOWNYCH (klucze bez mfa) ")
    else:
        print("Wszyscy uzytkownicy z kluczami sa poprawnie chronieni")

if __name__ == "__main__":
    audit_s3_buckets()
    audit_iam_users()