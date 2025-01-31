local font = require("wezterm").font
local harfbuzz_features = { "calt", "liga", "dlig", "ss01", "ss02", "ss03", "ss04", "ss05", "ss06", "ss07", "ss08" }
return {

	-- default font
	font = font({
		family = "JetBrainsMono Nerd Font Mono",
		-- family = "Monaspace Argon",
		-- family = "Monaspace Xenon",
		-- family = "Monaspace Radon",
		-- family = "Monaspace Krypton",
		-- weight = "Medium",
		harfbuzz_features = harfbuzz_features,
	}),

	font_rules = {
		{ -- Normal
			intensity = "Normal",
			italic = false,
			font = font({
				family = "JetBrainsMono Nerd Font Mono",
				weight = "Medium",
				harfbuzz_features = harfbuzz_features,
			}),
		},
		{ -- Bold
			intensity = "Bold",
			italic = false,
			font = font({
				family = "JetBrainsMono Nerd Font Mono",
				weight = "ExtraBold",
				harfbuzz_features = harfbuzz_features,
			}),
		},
		{ -- Half
			intensity = "Half",
			italic = false,
			font = font({
				family = "JetBrainsMono Nerd Font Mono",
				weight = "Book",
				harfbuzz_features = harfbuzz_features,
			}),
		},
		{ -- Normal italic
			intensity = "Normal",
			italic = true,
			font = font({
				family = "JetBrainsMono Nerd Font Mono",
				weight = "Regular",
				style = "Italic",
				harfbuzz_features = harfbuzz_features,
			}),
		},
		{ -- Bold italic
			intensity = "Bold",
			italic = true,
			font = font({
				family = "JetBrainsMono Nerd Font Mono",
				weight = "DemiBold",
				style = "Italic",
				harfbuzz_features = harfbuzz_features,
			}),
		},
		{ -- Half italic
			intensity = "Half",
			italic = true,
			font = font({
				family = "JetBrainsMono Nerd Font Mono",
				weight = "Thin",
				style = "Italic",
				harfbuzz_features = harfbuzz_features,
			}),
		},
	},
}
