###############################################################################
# SSH key for provisioned instances
################################################################################

resource "aws_key_pair" "vortexwest" {
  key_name   = "vortexwest"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIOo+RmKR0Pj18hv1uSoq5NMyVZuu+Hs2JvQnNlEbyap dulemars@CaspianSeaMonster"
}
