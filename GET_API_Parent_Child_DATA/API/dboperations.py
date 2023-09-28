from django.db import connection
from rest_framework.response import Response


def dbop_get_data():
    try:
        with connection.cursor() as cursor:
            cursor.callproc('public.get_complete_progress_data')
            result = cursor.fetchone()
            if result is not None:
                return result[0]
    except Exception as e:
        return Response({"error": str(e)})

