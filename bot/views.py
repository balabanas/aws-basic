from django.conf import settings
from django.core.files.storage import FileSystemStorage
from django.http import HttpResponse, HttpRequest


# Create your views here.
from django.shortcuts import render

from .models import Upload, UploadPrivate


def helloworld(request: HttpRequest):
    resp = f"""
    Host: {request.get_host()}<br>
    Port: {request.get_port()}<br>
    Key: {settings.SECRET_KEY[:10]}
    """
    return HttpResponse(resp)




def image_upload(request):
    if request.method == 'POST':
        image_file = request.FILES['image_file']
        image_type = request.POST['image_type']
        if settings.USE_S3:
            if image_type == 'private':
                upload = UploadPrivate(file=image_file)
            else:
                upload = Upload(file=image_file)
            upload.save()
            image_url = upload.file.url
        else:
            fs_storage = FileSystemStorage()
            filename = fs_storage.save(image_file.name, image_file)
            image_url = fs_storage.url(filename)
        return render(request, 'bot/upload.html', {
            'image_url': image_url
        })
    return render(request, 'bot/upload.html')
