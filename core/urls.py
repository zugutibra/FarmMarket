from django.urls import path
from .views import admin_login, admin_dashboard, admin_logout, FarmerRegistrationView, BuyerRegistrationView, LoginView

urlpatterns = [
    path('', admin_login, name='admin_login'),
    path('dashboard/', admin_dashboard, name='admin_dashboard'),
    path('logout/', admin_logout, name='admin_logout'),
    path('api/farmers/', FarmerRegistrationView.as_view(), name='farmer_registration'),
    path('api/buyers/', BuyerRegistrationView.as_view(), name='buyer_registration'),
    path('api/login/', LoginView.as_view(), name='login'),
]
