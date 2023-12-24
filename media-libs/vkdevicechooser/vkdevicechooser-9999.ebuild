# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson git-r3

DESCRIPTION="Vulkan Device Chooser Layer"
HOMEPAGE="https://github.com/aejsmith/vkdevicechooser"

EGIT_REPO_URI="https://github.com/aejsmith/vkdevicechooser"
KEYWORDS="amd64 ~arm arm64 ~loong ~ppc ~ppc64 ~riscv x86"

LICENSE="MIT"
SLOT="0"
IUSE=""

DEPEND="
	dev-util/vulkan-loader-headers
"
