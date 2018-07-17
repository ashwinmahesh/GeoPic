from django.shortcuts import render, HttpResponse, redirect
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from apps.login_registration.models import *

def index(request):
    return HttpResponse('You are set up correctly')

@csrf_exempt
def processLogin(request):
    if request.method!='POST':
        print('Someone is not posting')
        return HttpResponse('You are not posting!')
    username=request.POST['username']
    if len(User.objects.filter(username=username))==0:
        return JsonResponse('Invalid username')
    user = User.objects.get(username=username)
    
# Create your views here.
