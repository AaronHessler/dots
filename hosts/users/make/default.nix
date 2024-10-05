{ name ? "dragonfly", sudo ? false }:
{

	users.users = {
		"${name}" = {
			isNormalUser = true;
			extraGroups = if sudo then [ "wheel" "input" "uinput" ] else [];
		};
	};
}
