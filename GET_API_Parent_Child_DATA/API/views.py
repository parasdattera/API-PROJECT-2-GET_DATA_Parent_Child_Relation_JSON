from django.shortcuts import render
from rest_framework.decorators import api_view
from .dboperations import dbop_get_data
from rest_framework.response import Response
import json
from django.http import JsonResponse

# Create your views here.

@api_view(['GET'])
def API_get_data(request):
    data_json_str = dbop_get_data()

    if data_json_str:
        try:
            data = json.loads(data_json_str)
            return JsonResponse(data, safe=False)  # Set safe=False to allow non-dict JSON serialization
        except json.JSONDecodeError as e:
            return JsonResponse({"error": "Invalid JSON data", "detail": str(e)}, status=400)
    else:
        return JsonResponse({"message": "No data available"})