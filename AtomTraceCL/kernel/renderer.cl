typedef struct
{
    float3 origin;
    float3 direction;
}Ray;

typedef struct
{
    float radius;
    float3 pos;
    float3 emission;
    float3 color;
}Sphere;

typedef struct
{
    //float3 lookat;
    //float3 right;
    //float3 up;
    float3 pos;
    float3 upLeftPix;
    float3 dx; // camera right direction, per-pixel width
    float3 dy; // camera up direction, per-pixel height
}Camera;

// fov is the vertial fov angle
Ray castCamRay(int px, int py, __constant Camera* cam)
{
    float fx = (float)px;
    float fy = (float)py;
    float3 tar = cam->upLeftPix 
                 + cam->dx * fx
                 - cam->dy * fy;

    float3 orig = cam->pos;

    Ray ray;
    ray.direction = tar - orig;
    ray.direction = normalize(ray.direction);
    ray.origin = orig;
    return ray;
}

bool intersectSphere(const Sphere* obj, const Ray* ray)
{
    bool res = false;
    float3 po = obj->pos - ray->origin;
    float b = dot(po, ray->direction);
    float det = b*b - dot(po, po) + obj->radius * obj->radius;
    if (det < 0.0f)
    {
        return false;
    }
    return true;
}

__kernel void render(__global uchar* pOutput, int width, int height, __constant Camera* cam, __global float* counter)
{
    int pid = get_global_id(0);
    
    if (pid < width * height)
    {
        int px = pid % width;
        int py = pid / width;

        Ray cRay = castCamRay(px, py, cam);
        Sphere s0;
        s0.pos = (float3)(0.0f, 0.0f, -2.0f);
        s0.radius = 0.1f;

        bool bHit = intersectSphere(&s0, &cRay);

        float fx = (float)px / (float)(width - 1);
        float fy = (float)py / (float)(height - 1);

        uchar val = bHit * 255;
        float sc = 100.0f;
        pOutput[pid * 3] = val * cos(fx * sc + *counter);
        pOutput[pid * 3 + 1] = val * sin(fy * sc + *counter*2);
        pOutput[pid * 3 + 2] = val * cos(fx * sc - *counter*3);

    }
}