provider "aws" {
  region = "ap-northeast-1"
}

###########################
#VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
}

###########################
#Subnet
resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-northeast-1a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private_a" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "ap-northeast-1a"
}

resource "aws_subnet" "private_c" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "ap-northeast-1c"
}

###########################
#IGW
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
}

###########################
#Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

###########################
#Route Table と Public Subnetを関連付ける
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

###########################
#EC2
resource "aws_instance" "web" {
  ami           = "ami-09a81b370b76de6a2"
  instance_type = "t2.small" # 無料枠から外れるので注意。
  subnet_id     = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.allow_web.id]
  key_name      = "TestVPC"

  tags = {
    Name = "web-instance"
  }
}

###########################
#RDS
resource "aws_db_instance" "default" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  db_name              = "mydb"
  username             = "admin"
  password             = "622326KiriHiro"
  parameter_group_name = "default.mysql5.7"
  db_subnet_group_name = aws_db_subnet_group.subnet_group.name
  skip_final_snapshot  = true
  vpc_security_group_ids = [aws_security_group.allow_rds.id]
  publicly_accessible = false
}

resource "aws_db_subnet_group" "subnet_group" {
  name       = "my-db-subnet-group"
  # 以下のサブネット配列には異なるAZにある2つのプライベートサブネットのIDを含めます
  subnet_ids = [aws_subnet.private_a.id, aws_subnet.private_c.id]

  tags = {
    Name = "My DB Subnet Group"
  }
}


###########################
#EC2のセキュリティグループ
resource "aws_security_group" "allow_web" {
  name        = "allow_web"
  description = "Allow web inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

###########################
#RDSのセキュリティグループ
resource "aws_security_group" "allow_rds" {
  name        = "allow_rds"
  description = "Allow RDS inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 3306 # MySQLのデフォルトポート
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.public.cidr_block] # EC2インスタンスのサブネットからアクセスを許可
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

###########################
# S3バケット
resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-unique-bucket-name-shiroatohiro" # バケット名はユニークでなければなりません。

  tags = {
    Name = "My S3 Bucket"
  }
}

resource "aws_s3_bucket_cors_configuration" "my_cors_configuration" {
  bucket = aws_s3_bucket.my_bucket.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET"]
    #allowed_origins = ["http://math_qiita.shiroatohiro.com", "https://math_qiita.shiroatohiro.com"]
    allowed_origins = ["*"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
}

resource "aws_s3_bucket_public_access_block" "my_bucket_public_access_block" {
  bucket = aws_s3_bucket.my_bucket.id

  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls  = true
  restrict_public_buckets = true
}

###########################
resource "aws_iam_role" "ec2_s3_access" {
  name = "ec2_s3_access_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
      },
    ]
  })
}

resource "aws_iam_policy" "s3_access" {
  name        = "s3_access_policy"
  description = "A policy that allows EC2 instance to access specific S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ],
        Effect = "Allow",
        Resource = [
          "arn:aws:s3:::my-unique-bucket-name-shiroatohiro",  # バケット自体に対するアクセス
          "arn:aws:s3:::my-unique-bucket-name-shiroatohiro/*"   # バケットのARNを使用します。
        ],
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_s3_access" {
  role       = aws_iam_role.ec2_s3_access.name
  policy_arn = aws_iam_policy.s3_access.arn
}

resource "aws_iam_instance_profile" "ec2_s3_access_profile" {
  name = "ec2_s3_access_profile"
  role = aws_iam_role.ec2_s3_access.name
}