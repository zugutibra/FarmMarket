from django.shortcuts import get_object_or_404
from .models import Farmer, Buyer, Admin
from django.shortcuts import render, redirect
from django.contrib.auth.hashers import check_password
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from .models import Farmer, Buyer, Product
from .serializers import FarmerSerializer, BuyerSerializer


# Farmer Registration
class FarmerRegistrationView(APIView):
    def post(self, request):
        serializer = FarmerSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save(account_status='pending')  # Default status
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


# Buyer Registration
class BuyerRegistrationView(APIView):
    def post(self, request):
        serializer = BuyerSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class AddProductView(APIView):
    def post(self, request):
        data = request.data
        product = Product.objects.create(
            name=data.get('name'),
            description=data.get('description'),
            price=data.get('price'),
            quantity=data.get('quantity'),
            category=data.get('category'),
        )
        return Response({"success": True, "product_id": product.id}, status=status.HTTP_201_CREATED)

class ProductListView(APIView):
    def get(self, request):
        products = Product.objects.all().values()
        return Response({"success": True, "products": list(products)}, status=status.HTTP_200_OK)

# Login
class LoginView(APIView):
    def post(self, request):
        email = request.data.get('email')
        password = request.data.get('password')
        print(email, password)
        try:
            farmer = Farmer.objects.get(email=email)
            if check_password(password, farmer.password):
                return Response({"id": farmer.id, "role": "farmer"}, status=status.HTTP_200_OK)
        except Farmer.DoesNotExist:
            pass
        try:
            buyer = Buyer.objects.get(email=email)
            if check_password(password, buyer.password):
                return Response({"id": buyer.id, "role": "buyer"}, status=status.HTTP_200_OK)
        except Buyer.DoesNotExist:
            pass

        return Response({"error": "Invalid credentials"}, status=status.HTTP_401_UNAUTHORIZED)


def admin_dashboard(request):
    if 'admin_id' not in request.session:
        return redirect('admin_login')
    # Fetch all farmers and buyers
    farmers = Farmer.objects.all()
    buyers = Buyer.objects.all()

    if request.method == "POST":
        # Get the farmer ID and action from the submitted form
        farmer_id = request.POST.get("farmer_id")
        action = request.POST.get("action")

        # Fetch the Farmer object or return a 404 if not found
        farmer = get_object_or_404(Farmer, id=farmer_id)

        # Perform the action
        if action == "approve":
            farmer.account_status = "approved"
        elif action == "reject":
            farmer.account_status = "rejected"
        farmer.save()  # Save changes to the database

        # Redirect to avoid re-submission on page refresh
        return redirect("admin_dashboard")

    # Pass farmers and buyers to the template
    return render(request, "core/admin_dashboard.html", {
        "farmers": farmers,
        "buyers": buyers,
    })



def admin_login(request):
    if request.method == "POST":
        email = request.POST.get("email")
        password = request.POST.get("password")
        # Validate credentials
        try:
            admin = Admin.objects.get(email=email)
            if password == admin.password:
                request.session['admin_id'] = admin.id
                return redirect('admin_dashboard')
            else:
                return render(request, 'core/admin_login.html', {'error': 'Invalid password'})
        except Admin.DoesNotExist:
            return render(request, 'core/admin_login.html', {'error': 'Admin not found'})

    return render(request, 'core/admin_login.html')


def admin_logout(request):
    request.session.flush()
    return redirect('admin_login')
