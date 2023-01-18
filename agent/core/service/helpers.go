// Copyright 2022 Clivern. All rights reserved.
// Use of this source code is governed by the MIT
// license that can be found in the LICENSE file.

package service

import (
	"os"
	"strings"
)

// RemoveTrailingSlash removes any trailing slash
func RemoveTrailingSlash(url string) string {
	return strings.TrimRight(url, string(os.PathSeparator))
}
