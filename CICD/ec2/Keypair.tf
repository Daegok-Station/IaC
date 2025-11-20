#################################################################################
############################# AWS Public Key pair ###############################
#################################################################################

resource "aws_key_pair" "Daegok_Bastion_pub" {
  key_name = "Daegok-Bastion.pub"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCrdorYSiPMhxAbn/fPjTOf3AxrkC2eoQvRhjx/DX/qAVEYyFwzLPNDXqMFyta5dGjYPmEYIhx1YofN8aQXvezPRsxIcCv1X3vULi5oolDrNil5iOhvZab6cQeu9TvbXUzlx4jagvBZq06Q+hnNJEABdl2GFapkQCyhA4TtLSI22LNS7aBQzO/BsiXcOoe3UA4xsB1uthJ2KN8V9KDxnJaJq+3cfxio29FV3gZKFrUHyl4E/6X0EOkM86NqYKfA5bDlfl7D/b0d6De4RBF0qQIh2g6GxbKhy7MG/HQdoPnLG/Dx/zNLL82UmsKyKkeYWbVqYBVZJQV0BxPqCez/kEl7"
}

resource "aws_key_pair" "Daegok_Jenkins_pub" {
  key_name = "Daegok-Jenkins.pub"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCfepGQkYWzxBXsM91ucHV529EALw+3s7Oe0zAb6Vz2ZyYJprmNwjE+zt+3gTXnndXhG+Nia9Vu0b6QJ+RUcfLB1qXyPlx6qITDjd/4OfdXMaY93EKr4EIDMzjOD6HgHeZR+nozT+eD234whFR276T8IIijf0p5TdhjHc+wmPsFU6QLfXTFVOObcRxQ95DokjluBB6yhSuQti75kd1MYV1Q+AFRhP7I4wXqyBFNPPZQrI2dFr12k2jM7NkjZCwbsTpuwVJr62NDVpAJusUsXBtHpUjYqkiUjndZqz3kA71fBBLG4/DIAYEWFmti4bj2vghC4IdykWXsC+WxNTDX5et/"
}
