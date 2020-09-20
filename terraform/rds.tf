resource "aws_db_subnet_group" "db" {
  name       = "db_dbsubnet"
  subnet_ids = [aws_subnet.private1.id, aws_subnet.private2.id]

  tags = {
    Name = "${var.project_name}-private"
  }
}

resource "aws_db_instance" "db" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "mydb"
  username             = "dbuser"
  password             = "pass0000"
  parameter_group_name = "default.mysql5.7"
  db_subnet_group_name = aws_db_subnet_group.db.name
  skip_final_snapshot  = true
}
