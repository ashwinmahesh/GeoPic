from django.shortcuts import render, HttpResponse, redirect
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from apps.login_registration.models import *
import bcrypt
import base64

def index(request):
    return HttpResponse('You are set up correctly')

@csrf_exempt
def processLogin(request):
    if request.method!='POST':
        print('Someone is not posting')
        return HttpResponse('You are not posting!')
    if 'username' not in request.POST:
        return JsonResponse({'response':'Username not in post'})
    if 'password' not in request.POST:
        return JsonResponse({'response':'Password not in post'})
    print(request.POST)
    username=request.POST['username']
    if len(User.objects.filter(username=username))==0:
        # return JsonResponse('Invalid username')
        return JsonResponse({'response':'Username does not exist in database'})
    
    user = User.objects.get(username=username)
    # if bcrypt.checkpw(user.password.encode(), str(request.POST['password']).encode()):
    if request.POST['password']==user.password:
        response = {'response':'Successful Login', 'first_name':user.first_name, 'last_name':user.last_name, 'username':user.username, 'upload_count':user.upload_count}
        return JsonResponse(response)
    response = {'response':'Invalid Login'}
    return JsonResponse(response)

@csrf_exempt
def processRegister(request):
    if request.method!='POST':
        print('Someone is not posting for register')
        return HttpResponse('You are not posting')
    print(request.POST)
    first_name=request.POST['first_name']
    last_name=request.POST['last_name']
    username=request.POST['username']
    password=request.POST['password']
    if len(User.objects.filter(username=username))>0:
        return JsonResponse({'response':'Username already exists'})
    # hashedPW=bcrypt.hashpw(password.encode(), bcrypt.gensalt())
    print(first_name, last_name, username, password)
    User.objects.create(first_name=first_name, last_name=last_name, username=username, password=password)
    return JsonResponse({'response':'User successfully created'})
# Create your views here.

@csrf_exempt
def getRecentPosts(request):
    posts = Post.objects.all().order_by('-created_at')[0:40].values()
    data={
        'posts':list(posts)
    }
    return JsonResponse(data)

@csrf_exempt
#IMAGE GET NOT WORKING
def getPost(request):
    print("Recieved get post request")
    if request.method!='POST':
        return HttpResponse('You are not posting!')
    print(request.POST)
    post_id = request.POST['post_id']
    if len(Post.objects.filter(id=post_id))==0:
        return JsonResponse({'response':'This post does not exist'})
    post = Post.objects.get(id=post_id)
    # image_data_raw = post.image
    # image_data=image_data_raw.replace('\n', '').replace('\r', '').replace(' ', '')
    response = {'first_name':post.first_name, 'last_name':post.last_name, 'latitude':post.latitude, 'longitude':post.longitude, 'location':post.location, 'description':post.description, 'created_at':post.created_at}
    return JsonResponse(response)

def uploadFile(request):
    return render(request, 'login_registration/upload.html')

@csrf_exempt
def processUpload(request):
    print(request.POST)
    print(request.FILES)
    print("Your form is valid")
    with open('Files/image.png', 'wb+') as destination:
        for chunk in request.FILES['file'].chunks():
            destination.write(chunk)
    return redirect('/uploadFile/')

@csrf_exempt
def uploadImage(request):
    if request.method!='POST':
        return HttpResponse('You are not posting')
    print(request.POST['username'])
    user = User.objects.get(username=request.POST['username'])
    user.upload_count+=1
    user.save()
    image_data_raw = request.POST['image_data']
    description = request.POST['description']
    location = request.POST['location']
    latitude = request.POST['lat']
    longitude = request.POST['long']
    # image_data_raw.replace('\n','')
    Post.objects.create(first_name=user.first_name, last_name=user.last_name, username=user.username, longitude=longitude, latitude=latitude, location=location, description=description)
    return JsonResponse({'response':'upload recieved'})

@csrf_exempt
def fetchAll(request):
    posts=Post.objects.all().order_by("-created_at").values()
    data={
        'posts':list(posts)
    }
    return JsonResponse(data)
    
@csrf_exempt 
def searchPosts(request):
    if request.method!='POST':
        return HttpResponse('You are not posting!')
    print(request.POST)
    output=[]
    for post in Post.objects.all():
        postString = post.first_name + " " + post.last_name + " " + post.username + " " + post.location
        postString = postString.lower()
        if request.POST["searchFor"] in postString:
            output.append({'id':post.id, 'first_name':post.first_name, 'last_name':post.last_name, 'latitude':post.latitude, 'longitude':post.longitude, 'location':post.location, 'description':post.description, 'created_at':post.created_at})

    return JsonResponse({'posts':output})

def alamoTest(request):
    return JsonResponse({'response':'I am sending a response'})

@csrf_exempt
def alamoDataUpload(request):
    if request.method!='POST':
        print("Someone isn't posting")
        return HttpResponse("You are not posting!")
    print(request.FILES)
    with open('Files/image.jpg', 'wb+') as destination:
        for chunk in request.FILES['imageset'].chunks():
            destination.write(chunk)
    # for key in request.POST:
    #     print(key)
    # imageData_raw = base64.b64decode(request.POST)
    return JsonResponse({'response':'We have recieved your file!'})