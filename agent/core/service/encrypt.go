// Copyright 2023 Clivern. All rights reserved.
// Use of this source code is governed by the MIT
// license that can be found in the LICENSE file.

package service

import (
	"crypto/hmac"
	"crypto/sha256"
	"encoding/base64"
	"encoding/hex"
)

// HMAC encrypt base16
func base16_encrypt(key string, data string) string {
	hash := hmac.New(sha256.New, []byte(key))
	hash.Write([]byte(data))

	return hex.EncodeToString(hash.Sum(nil))
}

// HMAC encrypt base64
func base64_encrypt(key string, data string) string {
	hash := hmac.New(sha256.New, []byte(key))
	hash.Write([]byte(data))

	return base64.StdEncoding.EncodeToString(hash.Sum(nil))
}
