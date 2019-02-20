using System.Collections;
using System.Collections.Generic;
using UnityEngine;

// Credit: https://www.youtube.com/watch?v=6C4KfuW2q8Y

public class DoorTrigger : MonoBehaviour
{

    #region Attributes

    public Transform door;

    public Vector3 closedPosition = new Vector3(1.336f, 1.551f, -0.92f);
    public Vector3 openedPosition = new Vector3(1.336f, 5f, -0.92f);

    public float openSpeed = 5;

    private bool open = false;

    #endregion

    #region MonoBehaviour API

    private void Update()
    {
        if (open)
        {
            door.position = Vector3.Lerp(door.position,
                openedPosition, Time.deltaTime * openSpeed);
        }
        else
        {
            door.position = Vector3.Lerp(door.position,
                closedPosition, Time.deltaTime * openSpeed);
        }
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Player")
        {
            OpenDoor();
        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.tag == "Player")
        {
            CloseDoor();
        }
    }

    #endregion

    public void CloseDoor()
    {
        open = false;
    }

    public void OpenDoor()
    {
        open = true;
    }
}
