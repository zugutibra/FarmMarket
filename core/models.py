from django.db import models


class Admin(models.Model):
    email = models.EmailField(unique=True)
    password = models.CharField(max_length=255)  # Store hashed passwords in production!

    def __str__(self):
        return self.email


class Farmer(models.Model):
    name = models.CharField(max_length=100)
    email = models.EmailField(unique=True)
    password = models.CharField(max_length=255)  # Store hashed passwords for security
    farm_name = models.CharField(max_length=100)
    farm_location = models.CharField(max_length=255)
    account_status = models.CharField(
        max_length=20,
        choices=[('pending', 'Pending'), ('approved', 'Approved'), ('rejected', 'Rejected')],
        default='pending'
    )

    def __str__(self):
        return self.name

class Buyer(models.Model):
    name = models.CharField(max_length=100)
    email = models.EmailField(unique=True)
    password = models.CharField(max_length=255)  # Store hashed passwords for security

    def __str__(self):
        return self.name
