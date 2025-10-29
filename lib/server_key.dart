import 'package:googleapis_auth/auth_io.dart';

class GetServerKey {
  Future<String> serverKeyToken() async {
    final scopes = [
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/firebase.database',
      'https://www.googleapis.com/auth/firebase.messaging',
    ];
    final client = await clientViaServiceAccount(
      ServiceAccountCredentials.fromJson({
        "type": "service_account",
        "project_id": "event-app-d66c5",
        "private_key_id": "aac31caa3cd3d6eb019335c343849cc3a2c21d65",
        "private_key":
            "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQC6AHQsoPTgVpAL\n1LT/h/gxwwIIOzMkRtiycLZ7ckjXySrVJy6J7uYPy/uH1eYZfoQ1ejK+sbDJqsld\nXJUC59ncXo3Ny55gx/mu7LQXvGPGoA9Oel3EawZV54DLZpBYpEKk3yp5rYD0tAaN\n7N7kcMhFRZmvGWfc3HCjSZOjAbVgtC26/djayWjp7HBanEQVfzj6ZUgiakV83+T7\n+tRlhQbZhVkZirJOvDP8ZBSenJAh4JOCaAqD8IAlFyvY03itLxAx470Tq9Bw+7+g\nlY1+P8ZASrsLnU3jVKfuHBBN9mvvsC09ckgyIihN8EUJpHiE+6B5Mkjqgi6bYkCX\nJQlBTWAtAgMBAAECggEAFMxmsTPZVfmP92a0S4uIdwYDhOibvh927TMZ0KF1oD10\nHuwX8eAHFTadvHFwXqLtRS6SHI0xg8dnZ1tqJS5IR/JBwISXg+Jwmr0IoUvVS1lM\nBN49fHBsP7BYkEX6d5L8icOTlBIQ5Kv5vKaDQP+UgVx4RCJe4Q08QiIA0n4nKjYi\nxPtTfFWVkQQ33YWSsomlZYZZ9yP+GxcGT1zkPKuurV64a8hP1kyLPclz5Lz36jda\n26vYWrB8JVYeoIf7tsx/EgTZH1YlfuyVUeMOxL9A7x+6r1UC+AAcLRBUfvu1F4By\ntcAkCDSbbM/nhw4R/8GXdFTcer6Cv5ZeCLJ3TaQXiQKBgQDeDToh3hzeoG317C68\n/lrqQb1C3p/f7O16f+8griQTuSDvXDJ2+Xfm/FggM3xWJKPmhMFT5JHH8Gr12YZz\nldu26BRQBl4HXKEvaQapYdH2y9c73OUzCjCaXzAwDdbdghqXWITcIA5hyOxBgzrP\nJsRILeRl4ZtLKkZFdjy/HoBBhQKBgQDWcEmLoRFThFIOUmVhba1V8BP9s7fojPJk\nrA3zpGC4H1JVaIkyAr/v5DB4omUruKLTrbU+ptEAOhzu6VUrEjxFa2JOjrav84W9\nujjEK95ippDmXVbrLCyvHman3aySHW2vLdRopM9K+xQolziR1niO2ptrUIzrAGAf\ndPlxG+oQiQKBgD3TAveBBxq5IkSRcOXwD9IfYZmnsG3BYtFzo1m/Ao53QgNC8U4M\n4WRvp/23OAwoAXZiSg2YmzpG5xDycqvl8pm3fkhVrYJxOPOhU1h/wtzrHk8tjqcq\nVCP3EsyeXc+otMykucEsL7TsI1OOPSaGDapnFKuFKB7Cc3RNmlZAIMedAoGAUrNN\ned8tanM+ni1i0fdVgS4s14xHIhWxqee9HbjIYFocC7pcJwBue5saonum3vy/Nzno\nC3iUZC0FWZJ9eTX4LqGicT+S7zrQ2oIGQInWo18vxNg8nEgWF5d26ciRNGzLD2Ny\nZsUg+P7qIFlpxLzdE+L1S6buIfesGpWnWdr1I1kCgYBLmbtVVBkuylD5f+YLiDQn\nkUsgkSFSnomQsK7bpgDx+2M/IlsWcj9QSvdt2tqwlthAIRT6CVDy13lTnPsZzwcY\nzGKp3n85R0eytYdmq2kDprjfllXyWRfWHEdQMw831QaQB5LxT5/C0x04ncbnBtRB\nthwtco4lurakImu02Maa9w==\n-----END PRIVATE KEY-----\n",
        "client_email":
            "firebase-adminsdk-fbsvc@event-app-d66c5.iam.gserviceaccount.com",
        "client_id": "103150277954333033494",
        "auth_uri": "https://accounts.google.com/o/oauth2/auth",
        "token_uri": "https://oauth2.googleapis.com/token",
        "auth_provider_x509_cert_url":
            "https://www.googleapis.com/oauth2/v1/certs",
        "client_x509_cert_url":
            "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc%40event-app-d66c5.iam.gserviceaccount.com",
        "universe_domain": "googleapis.com",
      }),
      scopes,
    );
    final accessserverkey = client.credentials.accessToken.data;
    return accessserverkey;
  }
}
